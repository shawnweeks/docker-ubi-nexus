#!/usr/bin/python3

from entrypoint_helpers import env, gen_cfg, set_props

HOME = env["NEXUS_HOME"]
DATA_DIR = env['NEXUS_DATA_DIR']

gen_cfg("nexus.vmoptions.j2", "{}/bin/nexus.vmoptions".format(HOME))
gen_cfg("nexus.properties.j2", "{}/etc/nexus.properties".format(DATA_DIR))
gen_cfg("jetty-https.xml.j2", "{}/etc/jetty/jetty-https.xml".format(HOME))