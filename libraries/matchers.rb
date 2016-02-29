if defined?(ChefSpec)
  def install_td_agent_gem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_gem, :install, resource_name)
  end
  def upgrade_td_agent_gem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_gem, :upgrade, resource_name)
  end
  def remove_td_agent_gem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_gem, :remove, resource_name)
  end
  def purge_td_agent_gem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_gem, :purge, resource_name)
  end

  
  def create_td_agent_source(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_source, :create, resource_name)
  end
  def delete_td_agent_source(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_source, :delete, resource_name)
  end


  def create_td_agent_match(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_match, :create, resource_name)
  end
  def delete_td_agent_match(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_match, :delete, resource_name)
  end

  def create_td_agent_filter(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_filter, :create, resource_name)
  end
  def delete_td_agent_filter(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_filter, :delete, resource_name)
  end

  def create_td_agent_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_plugin, :create, resource_name)
  end
  def delete_td_agent_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:td_agent_plugin, :delete, resource_name)
  end
end
