<?php 
abstract class DataBase
{
    $conn = null;

    public function __construct()
    {
        try
        {
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        }
        catch(PDOException $e)
        {
        throw new Exception("Error Connecting To DB", 1);
        }   
    }

    
}


?>