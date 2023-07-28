<?php
define("PROJECT_ROOT_PATH", getenv('ROOT_PATH'));


// include the base controller file 
require_once PROJECT_ROOT_PATH . "/controller/api/base_controller.php";
require_once PROJECT_ROOT_PATH . "/controller/api/create_controller.php";
require_once PROJECT_ROOT_PATH . "/controller/api/get_controller.php";
require_once PROJECT_ROOT_PATH . "/controller/api/vote_controller.php";
require_once PROJECT_ROOT_PATH . "/controller/api/file_controller.php";
// include the use model file 
require_once PROJECT_ROOT_PATH . "/model/images_model.php";
require_once PROJECT_ROOT_PATH . "/model/lod_model.php";
require_once PROJECT_ROOT_PATH . "/model/database.php";

?>