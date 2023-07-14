<?php 

class BaseFileController
{

    public function createFolder(string $targetDir):void
    {
        try{
            mkdir($targetDir);
            }
            catch(Exception $e)
            {
                throw $e;
            }
    }

    public function checkFile(array $file, string $targetFile):array
    {
        $err = array();

        if (file_exists($targetFile))
        {
            array_push($err, "Sorry, file already exists.");

        }

        $size=26214400;
        // Check file size
        if ($file["size"]>$size )
        {
            array_push($err, " Sorry, your file is too large,  its larger than $size bytes.");

        }

        return $err;
    }


    public function moveFile(array $file, string $targetFile):void
    {
        $err = array();

        if (!move_uploaded_file($file["tmp_name"], $targetFile))
        {
            throw new Exception ( "Sorry, the file couldnt be moved to the final location");
        }

        
    }

}


?>