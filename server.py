#!/usr/bin/env python

import subprocess
from bottle import route, run, template, static_file


#Get the vboxnet0 ipaddr
intf = 'vboxnet0'
intf = 'virbr0'
intf_ip = subprocess.check_output(['ip', 'address', 'show', 'dev', intf]).split()
intf_ip = intf_ip[intf_ip.index('inet') + 1].split('/')[0]

#TODO Error checking
HOSTURL = "http://%s:4443" % (intf_ip)

BASEURL = "http://127.0.0.1:4443"


@route('/images/<os>/<release>/x86_64/<filename>')
def index(os, release, filename):
    print 'images/%s/%s/x86_64' % (os, release), filename
    return static_file(filename, root='images/%s/%s/x86_64' % (os, release))


MAP = {
#       'xx:xx': (pxe, ks/cloud-config') 
        'c6': ('centos7.pxe', 'centos7_minimal.ks'),
        'c7': ('centos7_local.pxe', 'centos7_minimal.ks'),
        }


@route('/kickstart/<mac>/<id>')
def index(mac, id):

    tplname = MAP[mac[-5:-3]][1]
    
    data = {'host_url': HOSTURL, 'base_url': BASEURL}
    
    tpl = file('templates/' + tplname).read()

    print "Recieved kickstart and mac %s  Serving %s" % (mac, tplname)
    return template(tpl, **data)



@route('/ipxe/<mac>/')
def index(mac):

    tplname = MAP[mac[-5:-3]][0]

    data = {'host_url': HOSTURL, 'base_url': BASEURL}

    tpl = file('templates/' + tplname).read()

    print "Recieved ipxe and mac %s  Serving %s" % (mac, tplname)
    return template(tpl, **data)



run(host='0.0.0.0', port=4443)
