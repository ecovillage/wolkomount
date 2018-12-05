deb:
	fpm \
		--depends bash\
		--depends davfs2\
		--depends zenity\
		--depends openssl\
		--version      `cat VERSION`\
		--architecture all\
		--input-type   dir\
		--output-type  deb\
		--name         "wolke7"\
		--description  "Wolke7 Tool"\
		--chdir        content\
		.

