#!/bin/bash

mysql -e "select table_schema, sum(data_length), sum(index_length), sum(data_free) from information_schema.tables group by table_schema" -b -N -s
