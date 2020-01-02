<?php
$servername = "mysql";
$username = "jcubillos555";
$password = "jcubillos555";
$db_name = "crud_app";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $db_name);

$con = mysqli_init();
//mysqli_ssl_set($con, NULL, NULL, {ca-cert filename}, NULL, NULL);
//mysqli_real_connect($con, "mysqldblab02.mysql.database.azure.com", "jcubillos555@mysqldblab02", Proviteq.1999, crud_app, 3306);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
?>
