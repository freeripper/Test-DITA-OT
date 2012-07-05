<?php
include 'init.php';
$user= new User($dbConnectionInfo);


$template = new Template("./templates/signUp.html");
echo $template->replace(array("username"=>"USER","confirmationLink"=>"LINK"));
$ses= Session::getInstance();

echo "XXX".Utils::extractEmail("Gicu test <sss@ss.ro>");

print_r($_SESSION);
?>