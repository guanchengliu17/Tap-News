#!/bin/bash
service redis-server start
service mongod start

pip install -r requirements.txt

cd ./web_server/client
npm install
npm run build &

cd ../server
npm install
nodemon &

cd ../../news_topic_modeling_service
python backfill.py &

cd ./server
python server.py &

cd ../../news_recommendation_service
python click_log_processor.py &
python recommendation_service.py &

cd ../backend_server
python service.py &

cd ../news_pipeline
python news_monitor.py &
python news_fetcher.py &
python news_deduper.py &




echo "=================================================="
read -p "PRESS [ENTER] TO TERMINATE PROCESSES." PRESSKEY

kill $(jobs -p)



