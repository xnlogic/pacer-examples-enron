#!/usr/bin/env bash

curl "https://s3.amazonaws.com/yuploader.infinitemonkeys.info/data/16351/2011-05-06-19-27-13/infochimps_enron-email-data-with-manager-subordinate-relationship-metadata.tar.bz2?AWSAccessKeyId=02S6Y1EFA7ZZ7KCZH3G2&Expires=1373066346&Signature=fLWqINWzcOpaovbACxLqcjiYX48%3D" -H "Cookie: _jsuid=2283889498" | tar -xj
mv infochimps_enron-email-data-with-manager-subordinate-relationship-metadata/Enron_Dataset_v0.12.graphml db/enron_data.graphml
mv infochimps_enron-email-data-with-manager-subordinate-relationship-metadata db/enron_data_files
ls -lh db/enron_data.graphml
