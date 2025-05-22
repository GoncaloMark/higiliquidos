from opentelemetry import metrics

# Get a meter from the global meter provider
meter = metrics.get_meter("saleor")

# Create a counter for product clicks
product_click_counter = meter.create_counter(
    name="product_clicks",
    description="The number of times a product is viewed",
    unit="1",
)
