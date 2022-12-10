Add-Type -AssemblyName System.Windows.FOrms;

$colCt = 5;
$rowCt = 5;

function addCell () {
    $panel = New-Object System.Windows.Forms.Panel;
    $panel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle;
    $panel.Width = "100";
    $panel.Height = "100";
    return $panel;
}

$main = New-Object System.Windows.Forms.Form;
$main.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog;
$main.Width = "525";
$main.Height = "400";

$cellCt = $rowCt * $colCt;
for ($i = 0; $i -lt $cellCt; $i++) {

    $cols = $colCt;

    [double]$row = [System.Math]::Truncate(([decimal]$i / $cols));
    [double]$col =  $i % $cols

    if ($col -gt 0) { $x = $col * 100 + 10; }
    else { $x = 10; }

    if ($row -gt 0) { $y = ($row * 100 + 10); }
    else { $y = 10; }
    
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