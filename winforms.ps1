Add-Type -AssemblyName System.Windows.FOrms;

## Table Size
$colCt = 10;

$rowCt = 10;

## Cell Size
$cellWidth = 50;
$cellHeight = 50;

## C
$marX = 10;
$marY = 10;

function addCell () {
    $panel = New-Object System.Windows.Forms.Panel;
    $panel.BorderStyle = [
    System.Windows.Forms.BorderStyle]::FixedSingle;
    $panel.Width = $cellWidth;
    $panel.Height = $cellHeight;
    return $panel;
}

$main = New-Object System.Windows.Forms.Form;
$main.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog;
$main.Width = ($cellWidth * $colCt) + $marX * 2 + $marX;
$main.Height = ($cellHeight * $rowCt) + $marY * 4 + $marY;

$cellCt = $rowCt * $colCt;
for ($i = 0; $i -lt $cellCt; $i++) {

    $cols = $colCt;

    [double]$row = [System.Math]::Truncate(([decimal]$i / $cols));
    [double]$col =  $i % $cols;

    ## Cell X Position
    if ($col -gt 0) { $x = $col * $cellWidth + $marX; }
    else { $x = $marX; }

    ## Cell Y Position
    if ($row -gt 0) { $y = ($row * $cellHeight + $mary); }
    else { $y = $marY; }
    
    ## Use $cell to store Object varible name to build dynamic expression 
    $cell = "`$cell$i";

    Invoke-Expression -Command "$cell = addCell;";
    Invoke-Expression -Command "$cell.Location = `"$x, $y`";"
    Invoke-Expression -Command "$cell.Add_MouseLeave({
        switch ($cell.BackColor)
        {
            ([System.Drawing.SystemColors]::Control)  { $cell.BackColor = [System.Drawing.Color]::Black; }
            ([System.Drawing.Color]::Black)    { $cell.BackColor = [System.Drawing.SystemColors]::Control; }
        }
    });";
    Invoke-Expression -Command "$cell.Add_MouseHover({
        switch ($cell.BackColor)
        {
            ([System.Drawing.SystemColors]::Control)  { $cell.BackColor = [System.Drawing.Color]::Black; }
            ([System.Drawing.Color]::Black)    { $cell.BackColor = [System.Drawing.SystemColors]::Control; }
        }
    });";
    Invoke-Expression -Command "`$main.Controls.Add($cell);";
}

$main.ShowDialog();