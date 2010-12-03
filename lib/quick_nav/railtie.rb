module QuickNav                                                                                                
  class Railtie < Rails::Railtie                                                                                       
    initializer "quick_nav.init_rails" do |app|                                                                
      QuickNav.init_rails
    end                                                                                                                
  end                                                                                                                  
end
