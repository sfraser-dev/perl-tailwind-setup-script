#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use File::Path qw(make_path);

sub modify_tailwind_config_js {
	my $file_name = "tailwind.config.js";
	my $line_old = "content";
	my $line_new = "content: [\"./public/**/*.{html,js}\"],";

	change_line($file_name, $line_old, $line_new);
}

sub modify_package_json {
	my $file_name = "package.json";
	my $line_old = "\"test\":";
	my $line_new = "    \"dev\": \"npx tailwindcss -i ./public/css/style.css -o ./public/css/tailwind.css --watch\"";

	change_line($file_name, $line_old, $line_new);
}

sub change_line () {
	my $file_name = shift;
	my $line_old = shift;
	my $line_new = shift;

	my @new_file;
	my $re = qr/$line_old/;
	open (my $fh, '<', $file_name) or die("Could not open '$file_name': $!");
	while(my $line = <$fh>) {
		if ($line =~ m/$line_old/) {
			say $line;
			push(@new_file, $line_new);
		}
		else {
			say $line;
			push (@new_file, $line);
		}
	}
	close $fh;
	open ($fh, '>', $file_name) or die ("Could not open file '$file_name': $!");
	foreach my $line (@new_file) {
		say $fh $line;
	}
	close $fh;
}

sub write_index_html_boiler_plate {
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

	my $file_name = "./public/index.html";
	open (my $fh, '>', $file_name) or die("Could not open '$file_name': $!");
	foreach my $line (@arr) {
		say $fh $line;
	}
	close $fh;
}

sub modify_style_css {
	my @arr;
	push(@arr, "\@tailwind base;");
	push(@arr, "\@tailwind components;");
	push(@arr, "\@tailwind utilities;");
	my $file_name = "./public/css/style.css";
	open (my $fh, '>', $file_name) or die("Could not open '$file_name': $!");
	foreach my $line (@arr) {
		say $fh $line;
	}
	close $fh;
}

#----- Main -----#
make_path("./public");
qx(touch ./public/index.html);
# Run npm init (creates package.json).
qx(npm init -y);
# Install Tailwind as a development dependency (creates node_modules/).
qx(npm install -D tailwindcss);
# Initialise Tailwind (creates tailwind.config.js).
qx(npx tailwindcss init);
# Give content property in tailwind.config.js an array of files to process.
modify_tailwind_config_js();
make_path("./public/css");
qx(touch ./public/css/style.css);
qx(touch ./public/css/tailwind.css);
# Populate index.html with boilerplate and a simple Tailwind class.
write_index_html_boiler_plate();
# Populate style.css with Tailwind classes.
modify_style_css();
# Modify package.json to run a dev script.
modify_package_json();
# Build the tailwind.css style sheet.
qx(npx tailwindcss -i ./public/css/style.css -o ./public/css/tailwind.css --watch);