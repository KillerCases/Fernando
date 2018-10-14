class ChargesController < ApplicationController

	def new
end

def create
  # Amount in cents
  @amount = (params[:amount].to_f*100).round

  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source  => params[:stripeToken],
    :metadata => { # optional
      :shipping_name =>params[:stripeShippingName],
      :shipping_line1 => params[:stripeShippingAddressLine1],
      :shipping_zip => params[:stripeShippingAddressZip],
      :shipping_state => params[:stripeShippingAddressState],
      :shipping_city => params[:stripeShippingAddressCity],
      :shipping_country => params[:stripeShippingAddressCountry]

    },
    # :shipping =>{
    #   :name => 'test',
    #   :address =>{
    #     :line1 => 'test'
    #   }
    # }
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'gbp'
  )

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
end	

end
