<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <style>
        #wrap {
            position: relative;
            width: 300px;
            height: 300px;
            border: 1px solid #ccc;
        }
        .box {
            position: absolute;
            width: 50px;
            height: 50px;
            background: #0094ff;
        }
        #crd1 {
            top:0;
            left:0;
        }
        #crd2 {
            top:0;
            right:0;
        }
        #crd3 {
            bottom: 0;
            left: 0;
        }
        #crd4 {
            bottom: 0;
            right: 0;
        }
        #crd5 {
            top:100px;
            left:100px;
        }
    </style>
</head>
<body>
    <div id="wrap">
        <div class="box" id="crd1">

        </div>
        <div class="box" id="crd2">

        </div>
        <div class="box" id="crd3">

        </div>
        <div class="box" id="crd4">

        </div>
        <div class="box" id="crd5">


        </div>
    </div>
</body>
</html>
