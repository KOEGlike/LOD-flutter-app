<?php
class BaseController
{
    
    
    protected function getUriSegments()
    {
        $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        $uri = explode( '/', $uri );
        return $uri;
    }
    
    protected function getQueryStringParams()
    {
        return parse_str($_SERVER['QUERY_STRING'], $query);
    }
   
    protected function sendResponse($code, $response, $headers = array("Content-Type: application/json"))
    {

        http_response_code($code);
        header_remove('Set-Cookie');
            if (is_array($headers) && count($headers)) {
                foreach ($headers as $header) {
                    header($header);
                }
            }
        header("Access-Control-Allow-Origin:*;", false);
        header("Access-Control-Allow-Methods:GET,PUT,PATCH,POST,DELETE;",false);
        echo json_encode($response);
        exit;
    }   

    protected function pdoErrorResponse($e)
    {
        json_response(500, ["success" => false, "message" => "faild to query to db:" . $e->getMessage() ]);
    }

    protected function methodNotSupported()
    {
        json_response(400, ["success" => false, "message" => "this method is not supportid on this endpoint"]);
    }

}?>