Add-Type -AssemblyName System.Windows.FOrms;

## Table Size
$colCt = 5;
$rowCt = 5;

## Cell Size
$cellWidth = 100;
$cellHeight = 100;

## Table Margin
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
$main.Width = $cellWidth * $colCt + 50;;
$main.Height = $cellHeight * $rowCt + 50;

$cellCt = $rowCt * $colCt;
for ($i = 0; $i -lt $cellCt; $i++) {

    $cols = $colCt;

    [double]$row = [System.Math]::Truncate(([decimal]$i / $cols));
    [double]$col =  $i % $cols

    if ($col -gt 0) { $x = $col * $cellWidth + $marX; }
    else { $x = $marX; }

    if ($row -gt 0) { $y = ($row * $cellHeight + $mary); }
    else { $y = $marY; }
    
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