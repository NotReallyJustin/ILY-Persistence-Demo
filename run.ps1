# As a side note, you can also do this in C++ or C, but we're not gonna do that bc it requires a lot of setup
# Also because some of y'all might not have GCC mingw installed

# https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.form?view=windowsdesktop-9.0
# Add-Type imports a .net framework object (basically for building Windows applications - PS1 is an automation tool built on top of .NET)
# By default, Windows only imports up to System.[]

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Add a handy font
$DefaultFont = New-Object System.Drawing.Font("Segoe UI Variable", 10)
$DefaultPadding = New-Object System.Windows.Forms.Padding
$DefaultPadding.Top = 30
$DefaultPadding.Bottom = 10
$DefaultPadding.Left = 30
$DefaultPadding.Right = 30

# Create random text to chuck in the popup
function Get-RandomText {
    $items = @(
        "I love you pookie pls send Crypto",
        "This thing's gonna make your HeartBleed",
        "ngl this is kinda rizzful of you",
        "I'm gonna love bomb you 🥰",
        "I always come back",
        "You can't live with your failures and where did that bring you?`nBack to me",
        "Are you a phish?`nBecause I'm hooked on to you"
    )

    return $items | Get-Random
}

# Create the popup
function Show-ILY {
    param (
        [String]$message
    )
    
    # 💛 Handy Tip: Pipe an object into Get-Member if you don't know what it does

    # Create a form. Think of this as the popup window itself
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "ILOVEYOU"         # Early 2000s reference - iykyk
    $form.Width = 300
    $form.height = 150
    $form.AutoSize = $true
    $form.Font = $DefaultFont
    $form.TopMost = $true           # The popup will always show up on top

    # Random Start Position for form
    $form.StartPosition = "Manual"
    $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
    $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

    $random = New-Object System.Random
    $randomX = $random.Next(0, $screenWidth - $form.Width)          # We do need to manually set pixel location - so this is how we're calculating it
    $randomY = $random.Next(0, $screenHeight - $form.Height)
    
    $form.Location = New-Object System.Drawing.Point($randomX, $randomY) # If this sounds confusing, dw. There's documentation and examples. The screen is like a Canvas

    # Add a label to the message!
    $label = New-Object System.Windows.Forms.Label
    $label.AutoSize = $true  # The label will automatically adjust based on text
    $label.Text = $message
    $label.Font = $DefaultFont
    $label.Padding = $DefaultPadding
    $form.Controls.Add($label)          # Actually add the stuff to the popup window. This feels like JSDOM

    # Add a button to give them the illusion of choice
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "Ok"
    $okButton.Size = New-Object System.Drawing.Size(75, 23)

    $buttonRight = $label.Right - $okButton.Width       # Sidequest: Set button location to be below the label
    $buttonBottom = $label.Bottom + 10
    $okButton.Location = New-Object System.Drawing.Point(   # Fix button location
        $buttonRight, 
        $buttonBottom
    )
    $form.Controls.Add($okButton)

    # 💗 Illusion of Choice - The popups just multiply when you click okay. Eventually we do need to close them all but 🤷‍♂️
    $okButton.Add_Click({
        Show-ILY (Get-RandomText)
        # $form.Close()         
    })

    # 💗 Prevent them from closing the form
    $form.Add_FormClosing({
        Show-ILY "Did you really think you could just close this?"
        $event.Cancel = $True
    })

    # 💗 Prevent them from closing the form
    # You can't cancel a "move" event. BUT: you could have it revert to its original position if you really didn't want to move 🤔
    $form.Add_Move({
        Show-ILY "I'm moved by the fact that you try to move that form`nBut no."
    })

    # 💗 Prevent them from minimizating the form
    $form.MinimizeBox = $False;

    # Actually display the stuff
    $form.ShowDialog()
}

# Loop of death :)
# 💗 The only way to stop this is to kill the Powershell process itself - which if we can Autostart it... is gonna be very hard
# Your average Joe is not gonna know how to close this
Show-ILY (Get-RandomText)