Facter.add("package_libssl100") do
        setcode do
		%x{if (dpkg -l|grep -q libssl1.0.0) then echo "true"; else echo "false";fi}.chomp
        end
end

Facter.add("package_openssl") do
        setcode do
		%x{if (dpkg -l|grep -q openssl) then echo "true"; else echo "false";fi}.chomp
        end
end

















