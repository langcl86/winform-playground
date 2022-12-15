Add-Type -AssemblyName System.Windows.FOrms;

$colCt = 10;
$rowCt = 5;
$marX = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - ([System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - 80);
$marY = 20;


function addCell () {
    $panel = New-Object System.Windows.Forms.Panel;
    $panel.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D;
    $panel.Width = "100";
    $panel.Height = "100";
    return $panel;
}

function Panel2 {

    if ($main.Controls.Contains($panel2)) {
         $main.Controls.Remove($panel2);
    }
    else { 
        [double]$p2x = [System.Math]::Round($main.Width / 4);
        [double]$p2y = [System.Math]::Round($main.Height / 4);
        
        [double]$p2w = [System.Math]::Round($main.Width / 2);
        [double]$p2h = [System.Math]::Round($main.Height / 1.75);

        $panel2.Width = $p2w;
        $panel2.Height = $p2h;

        $panel2.Location = "$p2x, $p2y";
        $main.Controls.Add($panel2);
        $panel2.BringToFront();
    }
}

$main = New-Object System.Windows.Forms.Form;
$main.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog;
$main.Width = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - 80;
$main.Height = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Height - 200;

$panel2 = [System.Windows.Forms.Panel]::new();
$panel2.Name = "Panel 2";
$panel2.BackColor = [System.Drawing.Color]::Chartreuse;
$panel2.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle;

$close_panel2 = [System.Windows.Forms.Button]::new();
$close_panel2.Text = " X ";
$close_panel2.Width = 30;
$close_panel2.Add_Click({Panel2;});

$panel2.Controls.Add($close_panel2);

$cellCt = $rowCt * $colCt;
for ($i = 0; $i -lt $cellCt; $i++) {

    $cols = $colCt;

    [double]$row = [System.Math]::Truncate(([decimal]$i / $cols));
    [double]$col =  $i % $cols;

    if ($col -gt 0) { $x = $col * 100 + $marX; }     ## Not First Column
    else { $x = $marX; }  ## First Column

    if ($row -gt 0) { $y = ($row * 100 + $marY); }   ## Not First Row 
    else { $y = $marY; }  ## First Row
    
    $cell = "`$cell$i";
    Invoke-Expression -Command "$cell = addCell;";
    Invoke-Expression -Command "$cell.Name = `"Cell $i`";";
    Invoke-Expression -Command "$cell.Location = `"$x, $y`";"
    Invoke-Expression -Command "$cell.Add_MouseLeave({
        switch ($cell.BackColor)
        {
            ([System.Drawing.SystemColors]::Control)  { $cell.BackColor = [System.Drawing.Color]::Black; }
            ([System.Drawing.Color]::Black)    { $cell.BackColor = [System.Drawing.SystemColors]::Control; }
        }
    });";
    Invoke-Expression -Command "$cell.Add_Click({
        Panel2;
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