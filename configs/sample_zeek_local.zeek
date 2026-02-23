# sample_zeek_local.zeek
# Minimal Zeek local override for lab logging experiments.

@load policy/protocols/conn
@load policy/protocols/dns

redef Site::local_nets += { 10.0.0.0/8 };
