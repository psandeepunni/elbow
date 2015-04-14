require 'aws-sdk-v1'
require 'net/dns'
require 'capistrano/dsl'
require 'logger'

def elastic_load_balancer(name, *args)

    include Capistrano::DSL

    AWS.config(:access_key_id => fetch(:aws_access_key_id), :secret_access_key => fetch(:aws_secret_access_key), :region => fetch(:aws_region))

    elb = AWS::ELB.new()

    elb_loadbalancer = elb.load_balancers[name]

    elb_loadbalancer.instances.each do |instance|
        hostname = instance.private_ip_address || instance.private_dns_name
        server(hostname, *args)
    end
end
