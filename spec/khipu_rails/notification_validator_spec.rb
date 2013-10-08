# encoding: utf-8
require 'spec_helper'

describe KhipuRails::NotificationValidator do
  context "Valid Notification" do
    before :all do
      @notification ||= {
        api_version: "1.2",
        receiver_id: "1392",
        notification_id: "dfs40ivmw7fz",
        subject: "Compra de Puntos Cumplo",
        amount: "2182",
        currency: "CLP",
        transaction_id: "",
        payer_email: "klahott@gmail.com",
        custom: "",
        notification_signature: "RiJM7qaRjgSBWfsGG7h0P1MHEo3spzXRGN+0BtyGQuZvLgwC6etXHqxxZ6y2r+i0IX5ugTeJhrOg+X2a2mm/MwDlmxoQDeq/Y824/U+zCNfsSDfO8O7+DZgkL2qoZuzMUlWb+DYzbYiVteIpc20ZZIE0PalK6lCr2zt8HM4K76rV5/7UVJvSAbHIDUeArSee/NLR9pq9Cy4t2oob0G4dm4uspEg6mYEtpbP4z85xAz5fZ1XesEycrRpKXblem6ciCEuUFgMGVGnFVxTUI1pkFfOopkoblJ93TdRwUMnHFOOsh37Gwsvk7Y/7W0r3+6wiFd6YJiPa79HzYEpUDSmyIw=="
      }

      KhipuRails.config = nil
      KhipuRails.configure do |config|
        config.add_receiver "1392", 'b174c94de0ec3ce4f1c3156e309de45e8ce0f9ef', :dev
      end
    end

    it "validates locally a valid transaction" do
      KhipuRails::NotificationValidator.is_valid?(@notification, :local).should == true
    end

    it "validates a valid transaction via webserver" do
      KhipuRails::NotificationValidator.is_valid?(@notification, :webservice).should == true
    end
  end

  context "Invalid Notification" do
    before :all do
      @notification ||= {
        api_version: "1.2",
        receiver_id: "1392",
        notification_id: "dfs40ivmw7fz",
        subject: "",
        amount: "2182",
        currency: "CLP",
        transaction_id: "",
        payer_email: "klahott@gmail.com",
        custom: "",
        notification_signature: "RiJM7qaRjgSBWfsGG7h0P1MHEo3spzXRGN+0BtyGQuZvLgwC6etXHqxxZ6y2r+i0IX5ugTeJhrOg+X2a2mm/MwDlmxoQDeq/Y824/U+zCNfsSDfO8O7+DZgkL2qoZuzMUlWb+DYzbYiVteIpc20ZZIE0PalK6lCr2zt8HM4K76rV5/7UVJvSAbHIDUeArSee/NLR9pq9Cy4t2oob0G4dm4uspEg6mYEtpbP4z85xAz5fZ1XesEycrRpKXblem6ciCEuUFgMGVGnFVxTUI1pkFfOopkoblJ93TdRwUMnHFOOsh37Gwsvk7Y/7W0r3+6wiFd6YJiPa79HzYEpUDSmyIw=="
      }

      KhipuRails.config = nil
      KhipuRails.configure do |config|
        config.add_receiver "1392", 'b174c94de0ec3ce4f1c3156e309de45e8ce0f9ef', :dev
      end
    end

    it "fails to validate locally an invalid transaction" do
      KhipuRails::NotificationValidator.is_valid?(@notification, :local).should == false
    end

    it "fails to validate an ivalid transaction via webserver" do
      KhipuRails::NotificationValidator.is_valid?(@notification, :webservice).should == false
    end
  end
end
