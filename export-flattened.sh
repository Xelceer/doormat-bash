./flatten-rc.sh > flattened/default.bashrc
sed 's/DOORMAT_STOPWATCH="1"/DOORMAT_STOPWATCH=0/g' flattened/default.bashrc > flattened/no-stopwatch.bashrc
