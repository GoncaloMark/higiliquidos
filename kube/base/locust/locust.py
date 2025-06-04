import json
import random
from locust import HttpUser, task, between
# from locust.exception import RescheduleTask

class SaleorGraphQLUser(HttpUser):
    wait_time = between(1, 3)
    
    def on_start(self):
        """Initialize user session"""
        self.headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
        self.checkout_id = None
        self.product_ids = []
        
        self.get_products()
    
    def graphql_request(self, query, variables=None, name=None):
        """Helper method to make GraphQL requests"""
        payload = {
            'query': query,
            'variables': variables or {}
        }
        
        headers = self.headers.copy()
        
        with self.client.post(
            '/graphql/',
            json=payload,
            headers=headers,
            name=name or query[:50] + '...',
            catch_response=True
        ) as response:
            try:
                result = response.json()
                if 'errors' in result:
                    response.failure(f"GraphQL errors: {result['errors']}")
                    return None
                return result.get('data')
            except json.JSONDecodeError:
                response.failure("Invalid JSON response")
                return None
    
    def get_products(self):
        """Fetch product IDs for use in other tests"""
        query = """
        query GetProducts($first: Int!, $channel: String!) {
            products(first: $first, channel: $channel) {
                edges {
                    node {
                        id
                        name
                        slug
                    }
                }
            }
        }
        """
        variables = {'first': 20, 'channel': 'default-channel'}
        
        data = self.graphql_request(query, variables, name="Get Products for Setup")
        if data and data.get('products', {}).get('edges'):
            self.product_ids = [
                edge['node']['id'] 
                for edge in data['products']['edges']
            ]
    
    @task(3)
    def browse_products(self):
        """Test product browsing"""
        query = """
        query GetProducts($first: Int!, $after: String, $channel: String!) {
            products(first: $first, after: $after, channel: $channel) {
                edges {
                    node {
                        id
                        name
                        slug
                        thumbnail {
                            url
                        }
                        pricing {
                            priceRange {
                                start {
                                    gross {
                                        amount
                                        currency
                                    }
                                }
                            }
                        }
                    }
                }
                pageInfo {
                    hasNextPage
                    endCursor
                }
            }
        }
        """
        variables = {
            'first': random.randint(10, 24),
            'channel': 'default-channel'
        }
        
        self.graphql_request(query, variables, name="Browse Products")
    
    @task(2)
    def get_product_details(self):
        """Test individual product page views"""
        # if not self.product_ids:
        #     raise RescheduleTask()
        
        product_id = random.choice(self.product_ids)
        query = """
        query GetProduct($id: ID!, $channel: String!) {
            product(id: $id, channel: $channel) {
                id
                name
                description
                slug
                images {
                    url
                }
                variants {
                    id
                    name
                    sku
                    pricing {
                        price {
                            gross {
                                amount
                                currency
                            }
                        }
                    }
                    quantityAvailable
                }
                category {
                    name
                    slug
                }
                attributes {
                    attribute {
                        name
                        slug
                    }
                    values {
                        name
                        slug
                    }
                }
            }
        }
        """
        variables = {'id': product_id, 'channel': 'default-channel'}
        
        self.graphql_request(query, variables, name="Product Details")
    
    @task(1)
    def browse_categories(self):
        """Test category browsing"""
        query = """
        query GetCategories($first: Int!, $channel: String!) {
            categories(first: $first) {
                edges {
                    node {
                        id
                        name
                        slug
                        children {
                            totalCount
                        }
                        products(channel: $channel) {
                            totalCount
                        }
                    }
                }
            }
        }
        """
        variables = {'first': 20, 'channel': 'default-channel'}
        
        self.graphql_request(query, variables, name="Browse Categories")