<?php

class DataBase
{
    public $conn=null;

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

    public function select($query = "" , $params = [])
    {
        try {
            $stmt = $this->executeStatement( $query , $params );
            $result = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);				
            $stmt->close();
            return $result;
        } catch(Exception $e) {
            throw New Exception( $e->getMessage() );
        }
        return false;
    }
    
    public function executeStatement($query = "" , $params = [])
    {
        try {
            $stmt = $this->connection->prepare( $query );
            if($stmt === false) {
                throw New Exception("Unable to do prepared statement: " . $query);
            }
            if( $params ) {
                for ($i=0; $i < length($length); $i++) { 
                    $stmt->bind_param($params[$i][0], $params[$i][1]);
                }
            }
            $stmt->execute();
            return $stmt;
        } catch(Exception $e) {
            throw New Exception( $e->getMessage() );
        }	
    }
}


?>
