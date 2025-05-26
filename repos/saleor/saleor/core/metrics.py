from opentelemetry import metrics

# Get a meter from the global meter provider
meter = metrics.get_meter("saleor")

# Create a counter for product clicks
product_click_counter = meter.create_counter(
    name="product_clicks",
    description="The number of times a product is viewed",
    unit="1",
)

# Create a counter for unfinished carts
unfinished_cart_counter = meter.create_counter(
    name="unfinished_carts",
    description="The number of carts that were created but not completed",
    unit="1",
)

# Create a counter for completed checkouts to track conversion
completed_checkout_counter = meter.create_counter(
    name="completed_checkouts",
    description="The number of checkouts that were successfully completed",
    unit="1",
)

# Create a counter for user registrations
user_registration_counter = meter.create_counter(
    name="user_registrations",
    description="The number of new user registrations",
    unit="1",
)

# Create a counter for payment failures
payment_failure_counter = meter.create_counter(
    name="payment_failures",
    description="The number of failed payment attempts",
    unit="1",
)

# Create an up-down counter for total sales value
total_sales_counter = meter.create_up_down_counter(
    name="total_sales_value",
    description="The total gross value of all completed sales",
    unit="currency",
)

# Create a histogram for order values to calculate average order value (AOV)
order_value_histogram = meter.create_histogram(
    name="order_values",
    description="Distribution of order values for AOV calculation",
    unit="currency",
)
