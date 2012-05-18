require_recipe "nginx::source"

node[:rails_unicorn][:sites].each do |site|

  bash "create deploy directory" do
    code <<-EOH
      mkdir #{site[:deploy_path]}
      chown #{site[:deploy_user]}:#{site[:deploy_group]} #{site[:deploy_path]}
    EOH
    not_if do File.exists?( site[:deploy_path] ) end
  end

  template "/etc/nginx/sites-available/#{site[:sitename]}" do
    source "rails_unicorn.erb"
    mode 0644
    variables(
      :sitename    => site[:sitename],
      :deploy_path => site[:deploy_path],
      :domains     => site[:domains]
    )
  end

  nginx_site site[:sitename]

end