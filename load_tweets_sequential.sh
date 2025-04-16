#!/bin/bash

files=$(find data/*)
for file in $files; do
	echo $files
done
echo '================================================================================'
echo 'load denormalized'
echo '================================================================================'
time for file in $files; do
        # copy your solution to the twitter_postgres assignment here
    unzip -p "${file}" | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:1051/postgres -c "COPY tweets_jsonb(data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
done

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
time for file in $files; do
    echo
    # copy your solution to the twitter_postgres assignment here
    python3 -u load_tweets.py --db=postgresql://postgres:pass@localhost:1052 --inputs "${file}"
done

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
time for file in $files; do
    python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:1053/ --inputs $file
done
