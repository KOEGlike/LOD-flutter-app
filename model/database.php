<?php

abstract class DataBase
{
    $conn=null;

    public function __construct()
    {
        $servername= getenv('DB_SERVER_NAME');
        $dbname = getenv('DB_NAME');
        $username= getenv('DB_USER_NAME');
        $password=getenv('DB_PASS');
        
        try {
            $this->conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            throw new Exception("Error Connecting To DB: " . $e->getMessage(), 1);
        }
    }

   
}

?>
