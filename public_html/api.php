<?php
function json_response($code, $response, $header = "Content-Type: application/json")
{

    http_response_code($code);
    header("$header;",false);
    header("Access-Control-Allow-Origin:*;", false);
    header("Access-Control-Allow-Methods:GET,PUT,PATCH,POST,DELETE;",false);
    echo json_encode($response);
    exit;
}


/*function makedir($dirname)
{
    try
    {
        mkdir($dirName);

    }
    catch(Exception $e)
    {
        json_response(500, ["success" => false, "message" => "failed to make directory: " . $e->getMessage() ]);
    }
}*/

function pdo_error_response($e)
{
    json_response(500, ["success" => false, "message" => "faild to query to db:" . $e->getMessage() ]);
}

function method_not_supported()
{
    json_response(500, ["success" => false, "message" => "this method is not supportid on this endpoint"]);
}

$servername = "localhost";
$username = "id20173908_sopuser";
$password = "fkrj(N@8ZBOZ\>_y";
$dbname = "id20173908_sopdb";

try
{
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);

    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
}
catch(PDOException $e)
{
    json_response(500, ["success" => false, "message" => "Connection failed to db: " . $e->getMessage() ]);
}

$parts = explode("/", $_SERVER["REQUEST_URI"]);
$api_index = array_search("api.php", $parts);
if ($api_index !== false && count($parts) > $api_index + 1)
{

    $uri = implode("/", array_slice($parts, $api_index + 1));
    $uri = strtok($uri, '?');

}

if ($uri === "upload/create")
{
    if ($_SERVER["REQUEST_METHOD"] === "POST")
    {
        if ($_POST["name"] == false)
        {
            json_response(400, ["success" => false, "message" => "name variable was not sent"]);
        }

        $name = $_POST["name"];

        try
        {
            $stmt = $conn->prepare('INSERT INTO  sopNames(name) VALUES (:name)');
            $stmt->bindParam(":name", $name);
            $stmt->execute();
        }
        catch(PDOException $e)
        {
            pdo_error_response($e);
        }
       
        $last_sop_id = $conn->lastInsertId();
        $target_dir = "images/$last_sop_id";

        mkdir($target_dir);
        json_response(200, ["success" => true, "id" => $last_sop_id]);
    }
    else
    {
        method_not_supported();
    }
}

elseif ($uri === "upload/image")
{
    if ($_SERVER["REQUEST_METHOD"] === "POST")
    {

        if ($_FILES["file"] == false && $_POST["id"] == false)
        {
            json_response(400, ["success" => false, "message" => "photo and id was not sent"]);
        }
        elseif ($_FILES["file"] == false)
        {
            json_response(400, ["success" => false, "message" => "photo was not sent"]);
        }
        elseif ($_POST["id"] == false)
        {
            json_response(400, ["success" => false, "message" => "id variable was not sent"]);
        }
        $uploaded_photo = $_FILES['file'];
        $id = $_POST["id"];
        $target_dir = "images/$id/";
        $target_file = $target_dir . basename($uploaded_photo["name"]);
        $stmt = $conn->prepare("INSERT INTO kepek (file_Name, origin_id) VALUES (:name, :origin_id )");
        $stmt->bindParam(":name", $uploaded_photo["name"]);
        $stmt->bindParam(":origin_id", $id);
        $stmt->execute();

        $err = "";

        // Check if file already exists
        if (file_exists($target_file))
        {
            $err .= " Sorry, file already exists.";

        }

        // Check file size
        if ($uploaded_photo["size"]> 26214400)
        {
            $err .= " Sorry, your file is too large.";

        }
        // Check if $uploadOk is set to 0 by an error
        

        if (!move_uploaded_file($uploaded_photo["tmp_name"], $target_file))
        {
            $err .= " Sorry, the file couldnt be moved to the final location";
        }

        if ($err != "")
        {
            json_response(500, ["success" => false, "message" => $err]);
        }
        else
        {
            json_response(200, ["success" => true]);
        }
    }
    else
    {
        method_not_supported();
    }
}

elseif ($uri === "get")
{
    if ($_SERVER["REQUEST_METHOD"] === "GET")
    {
        if ($_GET["id"] == false)
        {
            json_response(400, ["success" => false, "message" => "id was not sent"]);
        }
       
        $SOPid = $_GET["id"];
        try
        {
            $stmt = $conn->prepare("SELECT * FROM kepek WHERE origin_id = :value");
            $stmt->bindParam(":value", $SOPid);
            $stmt->execute();
            $kepek = $stmt->fetchAll(PDO::FETCH_ASSOC);

            $stmt = $conn->prepare("SELECT * FROM sopNames WHERE id = :value");
            $stmt->bindParam(":value", $SOPid);
            $stmt->execute();
            $nev = $stmt->fetchAll(PDO::FETCH_ASSOC);
        }
        catch(PDOException $e)
        {
            pdo_error_response($e);
        }

        json_response(200, ["success" => true, "images" => $kepek, "name" => $nev[0]["name"]]);

    }
    else
    {

        method_not_supported();
    }
}
elseif ($uri === "vote")
{
    if ($_SERVER["REQUEST_METHOD"] === "POST")
    {
        if ($_POST["isyes"] == "true" || $_POST["isyes"] == "false")
        {
            try
            {
                if ($_POST["isyes"] == "true")
                {
                    $stmt = $conn->prepare("UPDATE kepek SET votes = votes+1, votes_amount = votes_amount + 1 WHERE id = :id");
                }
                elseif ($_POST["isyes"] == "false")
                {
                    $stmt = $conn->prepare("UPDATE kepek SET votes = votes-1, votes_amount = votes_amount + 1 WHERE id = :id");
                }
                $stmt->bindParam(":id", $_POST["id"]);
                $stmt->execute();
            }
            catch(PDOException $e)
            {
                pdo_error_response($e);
            }

            json_response(200, ["success" => true]);
        }
        else
        {
            json_response(400, ["success" => false, "message" => 'NOT A VALID "vote" variabe option']);
        }
    }
    else
    {
        method_not_supported();
    }
}
else
{
    json_response(400, ["success" => false, "message" => "this endpoint does not exist"

    ]);
}
?>