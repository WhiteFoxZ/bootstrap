<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <style>
        div {
            display: inline-block;
            border: 3px solid black;
        }
        .container {
            margin: 40px;
            width: 800px;
            height: 1000px;
        }
        .box1 {
            width: 200px;
            height: 100px;
            background: red;
            position: relative;
            top: 100px;
            left: 100px;
        }
        .box2 {
            width: 200px;
            height: 100px;
            background: blue;
            position: absolute;
            top: 100px;
            left: 100px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="box1">

        </div>
        <div class="box2">

        </div>
    </div>
</body>
</html>
