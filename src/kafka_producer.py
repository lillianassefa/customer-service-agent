# Customer Service Agent - Kafka Producer
# Automation Engineer Profile - Event-driven automation

import os
import json
import logging
from datetime import datetime
from typing import Dict, Any
from kafka import KafkaProducer
from kafka.errors import KafkaError

logger = logging.getLogger(__name__)

class CustomerServiceKafkaProducer:
    """
    Kafka producer for Customer Service Agent events
    Demonstrates automation engineering event-driven architecture
    """
    
    def __init__(self, bootstrap_servers: str = None, topic: str = None):
        """
        Initialize Kafka producer with cost and performance optimization
        """
        self.bootstrap_servers = bootstrap_servers or os.getenv('KAFKA_BOOTSTRAP_SERVERS', 'localhost:9092')
        self.topic = topic or os.getenv('KAFKA_TOPIC', 'customer_queries')
        
        # Cost-sensitive: Configure producer for optimal performance
        self.producer = KafkaProducer(
            bootstrap_servers=self.bootstrap_servers,
            value_serializer=lambda v: json.dumps(v).encode('utf-8'),
            key_serializer=lambda k: k.encode('utf-8') if k else None,
            # Performance optimization settings
            acks='1',  # Cost-effective: wait for leader acknowledgment
            retries=3,
            batch_size=16384,  # Optimize for throughput
            linger_ms=10,  # Reduce latency
            buffer_memory=33554432,  # 32MB buffer
            compression_type='gzip',  # Reduce network costs
            max_request_size=1048576,  # 1MB max request
        )
        
        logger.info(f"Kafka producer initialized for topic: {self.topic}")
    
    def send_customer_query(self, query: str, user_id: str = None, metadata: Dict[str, Any] = None):
        """
        Send customer query event to Kafka
        Demonstrates event-driven automation for query processing
        """
        try:
            event = {
                'event_type': 'customer_query',
                'timestamp': datetime.utcnow().isoformat(),
                'query': query,
                'user_id': user_id,
                'metadata': metadata or {},
                'environment': os.getenv('ENVIRONMENT', 'development'),
                'instance_id': os.getenv('INSTANCE_ID', 'unknown')
            }
            
            # Use query hash as key for partitioning (cost-sensitive: even distribution)
            key = str(hash(query) % 1000)
            
            future = self.producer.send(
                topic=self.topic,
                key=key,
                value=event
            )
            
            # Wait for send completion (latency-sensitive)
            record_metadata = future.get(timeout=10)
            
            logger.info(f"Query event sent to Kafka: {record_metadata.topic}:{record_metadata.partition}:{record_metadata.offset}")
            return True
            
        except KafkaError as e:
            logger.error(f"Failed to send query to Kafka: {e}")
            return False
        except Exception as e:
            logger.error(f"Unexpected error sending to Kafka: {e}")
            return False
    
    def send_response_event(self, query: str, response: str, processing_time: float, metadata: Dict[str, Any] = None):
        """
        Send response event to Kafka for monitoring and analytics
        Demonstrates automation engineering monitoring practices
        """
        try:
            event = {
                'event_type': 'customer_response',
                'timestamp': datetime.utcnow().isoformat(),
                'query': query,
                'response': response,
                'processing_time_ms': processing_time * 1000,  # Convert to milliseconds
                'metadata': metadata or {},
                'environment': os.getenv('ENVIRONMENT', 'development'),
                'instance_id': os.getenv('INSTANCE_ID', 'unknown')
            }
            
            key = str(hash(query) % 1000)
            
            future = self.producer.send(
                topic=self.topic,
                key=key,
                value=event
            )
            
            record_metadata = future.get(timeout=10)
            logger.info(f"Response event sent to Kafka: {record_metadata.topic}:{record_metadata.partition}:{record_metadata.offset}")
            return True
            
        except KafkaError as e:
            logger.error(f"Failed to send response to Kafka: {e}")
            return False
        except Exception as e:
            logger.error(f"Unexpected error sending response to Kafka: {e}")
            return False
    
    def send_error_event(self, error_type: str, error_message: str, query: str = None, metadata: Dict[str, Any] = None):
        """
        Send error event to Kafka for monitoring and alerting
        Demonstrates automation engineering error handling
        """
        try:
            event = {
                'event_type': 'error',
                'timestamp': datetime.utcnow().isoformat(),
                'error_type': error_type,
                'error_message': error_message,
                'query': query,
                'metadata': metadata or {},
                'environment': os.getenv('ENVIRONMENT', 'development'),
                'instance_id': os.getenv('INSTANCE_ID', 'unknown')
            }
            
            key = str(hash(error_type) % 1000)
            
            future = self.producer.send(
                topic=self.topic,
                key=key,
                value=event
            )
            
            record_metadata = future.get(timeout=10)
            logger.info(f"Error event sent to Kafka: {record_metadata.topic}:{record_metadata.partition}:{record_metadata.offset}")
            return True
            
        except KafkaError as e:
            logger.error(f"Failed to send error to Kafka: {e}")
            return False
        except Exception as e:
            logger.error(f"Unexpected error sending error to Kafka: {e}")
            return False
    
    def send_metrics_event(self, metrics: Dict[str, Any]):
        """
        Send metrics event to Kafka for cost and performance monitoring
        Demonstrates automation engineering metrics collection
        """
        try:
            event = {
                'event_type': 'metrics',
                'timestamp': datetime.utcnow().isoformat(),
                'metrics': metrics,
                'environment': os.getenv('ENVIRONMENT', 'development'),
                'instance_id': os.getenv('INSTANCE_ID', 'unknown')
            }
            
            key = 'metrics'
            
            future = self.producer.send(
                topic=self.topic,
                key=key,
                value=event
            )
            
            record_metadata = future.get(timeout=10)
            logger.info(f"Metrics event sent to Kafka: {record_metadata.topic}:{record_metadata.partition}:{record_metadata.offset}")
            return True
            
        except KafkaError as e:
            logger.error(f"Failed to send metrics to Kafka: {e}")
            return False
        except Exception as e:
            logger.error(f"Unexpected error sending metrics to Kafka: {e}")
            return False
    
    def close(self):
        """
        Close Kafka producer connection
        Demonstrates proper resource cleanup
        """
        try:
            self.producer.flush(timeout=10)
            self.producer.close(timeout=10)
            logger.info("Kafka producer closed successfully")
        except Exception as e:
            logger.error(f"Error closing Kafka producer: {e}")

# Global producer instance for cost optimization
_kafka_producer = None

def get_kafka_producer() -> CustomerServiceKafkaProducer:
    """
    Get or create Kafka producer instance (cost-sensitive: singleton pattern)
    """
    global _kafka_producer
    if _kafka_producer is None:
        _kafka_producer = CustomerServiceKafkaProducer()
    return _kafka_producer

def send_query_event(query: str, user_id: str = None, metadata: Dict[str, Any] = None) -> bool:
    """
    Convenience function to send query event
    """
    producer = get_kafka_producer()
    return producer.send_customer_query(query, user_id, metadata)

def send_response_event(query: str, response: str, processing_time: float, metadata: Dict[str, Any] = None) -> bool:
    """
    Convenience function to send response event
    """
    producer = get_kafka_producer()
    return producer.send_response_event(query, response, processing_time, metadata)

def send_error_event(error_type: str, error_message: str, query: str = None, metadata: Dict[str, Any] = None) -> bool:
    """
    Convenience function to send error event
    """
    producer = get_kafka_producer()
    return producer.send_error_event(error_type, error_message, query, metadata)

def send_metrics_event(metrics: Dict[str, Any]) -> bool:
    """
    Convenience function to send metrics event
    """
    producer = get_kafka_producer()
    return producer.send_metrics_event(metrics) 