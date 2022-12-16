#
##
### Table Settings 
#
## Table Size
$colCt = 7;
$rowCt = 5;

## Cell Size
$cellWidth = 50;
$cellHeight = 50;

## Table Margin
$marX = 10;
$marY = 10;
#

function addCell () {
<#
    .SYNOPSIS
        Create a new Form Panel and return Control object
#>
    $panel = New-Object System.Windows.Forms.Panel;
    $panel.BorderStyle = [
    System.Windows.Forms.BorderStyle]::FixedSingle;
    $panel.Width = $cellWidth;
    $panel.Height = $cellHeight;
    return $panel;
}

function main {
<#
    .SYNOPSIS 
        Display Windows Form dialog containing a custom sized table.
#>
    Add-Type -AssemblyName System.Windows.FOrms;

    ## Create Main Form
    $main = New-Object System.Windows.Forms.Form;
    $main.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog;
    $main.Width = ($cellWidth * $colCt) + $marX * 2 + $marX;
    $main.Height = ($cellHeight * $rowCt) + $marY * 4 + $marY;

    ## Create Cells
    $cellCt = $rowCt * $colCt;
    for ($i = 0; $i -lt $cellCt; $i++) {
        $cols = $colCt;

        ## Find Row & Column # for cell
        [double]$row = [System.Math]::Truncate(([decimal]$i / $cols));
        [double]$col =  $i % $cols;

        ## Cell X Position
        if ($col -gt 0) { $x = $col * $cellWidth + $marX; }
        else { $x = $marX; } # First Column

        ## Cell Y Position
        if ($row -gt 0) { $y = ($row * $cellHeight + $mary); }
        else { $y = $marY; } # Firest Row
    
        ## Get variable for current object- script creates objects
        $cell = "`$cell$i";

        ## Invoke command using $cell string for the current object
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
}
main;
