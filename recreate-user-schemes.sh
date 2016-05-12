#!/bin/bash
echo "
 require 'xcodeproj'
 project = Xcodeproj::Project.open '$1.xcodeproj'
 project.recreate_user_schemes
 project.save
" | ruby
