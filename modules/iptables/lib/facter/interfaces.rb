Facter.add("sci_ext_interface") do
        setcode do
                %x{ip r|grep default|cut -f5 -d' '}.chomp end
end

Facter.add("sci_int_interfaces") do
        setcode do
                %x{ifconfig|grep "Link encap"|grep -v lo|cut -f1 -d' '|grep -v $(ip r|grep default|cut -f5 -d' ')|tr '\n' ','}.chomp end
end

