class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :redirect_to_signup, only: [:new]

  def create
    customer = if current_user.stripe_id?
                 Stripe::Customer.retrieve(current_user.stripe_id)
               else
                 Stripe::Customer.create(email: current_user.email)
                end

    customer.source = params[:stripeToken]
    customer.plan = 'monthly'
    customer.save

    # subscription = customer.subscriptions.retrieve(current_user.stripe_subscription_id)
    subscription = customer.subscriptions.first
    # subscription = customer.subscriptions.create(
    #   source: params[:stripeToken],
    #   plan: 'monthly'
    # )

    card = customer.sources.first

    current_user.update(
      stripe_id: customer.id,
      stripe_subscription_id: subscription.id,
      card_last4: card['last4'],
      card_exp_month: card['exp_month'],
      card_exp_year: card['exp_year'],
      card_type: card['brand']
    )

    # Update user
    current_user.premium!

    flash[:notice] = "Thank you for supporting Blocipedia!, #{current_user.email}! Your account has been successfully upgraded to a Premium Account. Congratulations."
    redirect_to edit_user_registration_path(current_user)

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_subscription_path
  end

  def edit
    @stripe_btn_data = {
      key: Rails.configuration.stripe[:publishable_key].to_s,
      description: "Blocipedia Premium Membership - #{current_user.user_name}"
    }
  end

  def new
    @stripe_btn_data = {
      key: Rails.configuration.stripe[:publishable_key].to_s,
      description: "Blocipedia Premium Membership - #{current_user.user_name}"
    }
  end

  def update
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    subscription = customer.subscriptions.retrieve(current_user.stripe_subscription_id)
    subscription.source = params[:stripeToken]
    subscription.save

    card = customer.sources.first

    current_user.update(
      card_last4: card['last4'],
      card_exp_month: card['exp_month'],
      card_exp_year: card['exp_year'],
      card_type: card['brand']
    )

    # redirect_to edits(old_user)

    flash[:notice] = "Your card on file has been updated successfully. Thank you for supporting Blocipedia!, #{current_user.email}!"
    redirect_to edit_user_registration_path(current_user)
  end

  def destroy
    subscription = Stripe::Subscription.retrieve(current_user.stripe_subscription_id)
    subscription.delete(at_period_end: true)
    current_user.standard!
    current_user.wikis.update_all(private: false)

    current_user.update(stripe_subscription_id: nil)

    redirect_to edit_user_registration_path(current_user)
    flash[:notice] = 'Your account has been downgraded to a Standard Account. All Wikis are now public.'
  end

  private

  def redirect_to_signup
    unless user_signed_in?
      session['user_return_to'] = new_subscription_path
      redirect_to new_user_registration_path
    end
  end
end
