#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);

sub tailwindConfigJs {
	my @newFile;
	my $fileName = "tailwind.config.js";
	open (my $fp, '<', $fileName) or die("Could not open '$fileName': $!");
	while(my $line = <$fp>) {
		if ($line =~ m/content/) {
			say $line;
			push(@newFile, "content: [\"./public/**/*.{html,js}\"],");
			
		}
		else {
			say $line;
			push (@newFile, $line);
		}
	}
	close $fp;
	system("rm $fileName"); 
	open ($fp, '>', $fileName) or die ("Could not open file '$fileName': $!");
	foreach my $i (@newFile) {
		say $fp $i;
	}
	close $fp;
}
sub boilerPlate {
	my @arr;
	push(@arr, "<!DOCTYPE html>");
	push(@arr, "<html lang=\"en\">");
	push(@arr, "<head>");
    push(@arr, "<meta charset=\"UTF-8\">");
    push(@arr, "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">");
    push(@arr, "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
    push(@arr, "<link rel=\"stylesheet\" href=\"./css/tailwind.css\">");
    push(@arr, "<title>Document</title>");
	push(@arr, "</head>");
	push(@arr, "<body>");
    push(@arr, "    <h1 class=\"bg-red-600\">tailwind test</h1>");
	push(@arr, "</body>");
	push(@arr, "</html>");
	my $fileName = "./public/index.html";
	open (my $fp, '>', $fileName) or die("Could not open '$fileName': $!");
	foreach my $i (@arr) {
		say $fp $i;
	}
	close $fp;
}

sub styleCss {
	my @arr;
	push(@arr, "\@tailwind base;");
	push(@arr, "\@tailwind components;");
	push(@arr, "\@tailwind utilities;");
	my $fileName = "./public/css/style.css";
	open (my $fp, '>', $fileName) or die("Could not open '$fileName': $!");
	foreach my $i (@arr) {
		say $fp $i;
	}
	close $fp;
}

sub packageJson {
	my @newFile;
	my $fileName = "package.json";
	open (my $fp, '<', $fileName) or die("Could not open '$fileName': $!");
	while(my $line = <$fp>) {
		if ($line =~ m/"test":/) {
			say $line;
			push(@newFile, "    \"dev\": \"npx tailwindcss -i ./public/css/style.css -o ./public/css/tailwind.css --watch\"");
		}
		else {
			say $line;
			push (@newFile, $line);
		}
	}
	close $fp;
	system("rm $fileName"); 
	open ($fp, '>', $fileName) or die ("Could not open file '$fileName': $!");
	foreach my $i (@newFile) {
		say $fp $i;
	}
	close $fp;
}

system("mkdir ./public");
system("touch ./public/index.html");
system("npm init -y");
system("npm install -D tailwindcss");
system("npx tailwindcss init");
tailwindConfigJs();
system("mkdir ./public/css");
system("touch ./public/css/style.css");
system("touch ./public/css/tailwind.css");
boilerPlate();
styleCss();
packageJson();
system("npx tailwindcss -i ./public/css/style.css -o ./public/css/tailwind.css --watch");
