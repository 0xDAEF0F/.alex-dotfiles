# fnm
set FNM_PATH "/opt/homebrew/bin"
if [ -d "$FNM_PATH" ]
  set PATH "$FNM_PATH" $PATH
  fnm env | source
end
