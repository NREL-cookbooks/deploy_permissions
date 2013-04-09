define :acl do
  acl = "group:#{params[:group]}:#{params[:modify]}"
  execute "setfacl -m #{acl} #{params[:name]}" do
    not_if "getfacl #{params[:name]} | grep -x '^#{params[:modify]}$'"
  end
end
