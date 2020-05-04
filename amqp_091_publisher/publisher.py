#!/usr/bin/env python
import json
import pika
import time
import random

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()

channel.queue_declare(queue='stocks')

tickers = ['IBM', 'GOOGL', 'AAPL', 'MSFT', 'VMW']
stock_exchanges = ['NYSE', 'LSE', 'JPX', 'SSE', 'SEHK']

while True:
    payload = {}
    payload["ticker"] = random.choice(tickers)
    payload["price"] = '{:.2f}'.format( random.random() * 1000)
    channel.basic_publish(exchange='',
                          routing_key='stocks',
                          body=json.dumps(payload),
                          properties = pika.BasicProperties(
                             delivery_mode = 2, # make message persistent
                             headers={'source': random.choice(stock_exchanges)}))
    print("Published ", payload)
    time.sleep(1)
