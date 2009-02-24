#!/usr/bin/python
#
# marker.py is a piece of uCon 2009 Capture The Flag code
# Copyright (C) 2002 Marcos Alvares <marcos.alvares@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#


files_path = '/ctf_ucon2/'

import sys
import os 
import pwd
import time

'''Print the correct way of using this program'''
def usage():
	print 'Usage:', sys.argv[0], '<user_id>'
	print 'Where <user_id> is your id and a valid one.'
	print


'''Check if the string passed to the program is a valid id registered at the id_file'''
def check_id (id): 
	if id == '':
		'<user_id> is \'\' (NULL)'
		return False
	else:
		'<user_id> is a legit string'
		'Opening the id filein read only'
		try:
			id_file = open(files_path + 'id_file', 'r')
		except:
			print 'The id file doesn\'t exist!'
			print
			raise SystemExit(1)
		'Checking if <user_id> is registered in the id_file'
		for entry in id_file:
			if entry.strip() == id.strip():
				'<user_id> is registered in the id_file'
				id_file.close()
				return True
		'<user_id> is not registered in the id_file'
		id_file.close()
		return False

'''Detects which tag file will be used'''
def detect_tag_file():
	'Detecting the challenge defeated'
	challenge_name = pwd.getpwuid(os.geteuid())[0]
	return files_path + 'tag_' + challenge_name

'''Check if the passed id is not already marked'''
def check_tag(id):
	'Opening the tag_file in read only mode'
	try:
		tag_file = open(detect_tag_file(), 'r')
	except:
		print 'The tag file (' + detect_tag_file() + ')', 'doesn\'t exist!'
		print
		raise SystemExit(1)
	'Seeing if the tag file was already marked'
	for entry in tag_file:
		if entry.strip() == id.strip():
			'<user_id> is already tagged'
			tag_file.close()
			return True
	'<user_id> is not marked, so we must mark now'
	tag_file.close()
	return False
			

'''Mark the passed id in the tag file'''
def mark_tag(id):
	'Opening the tag_file in append mode'
	try:
		tag_file = open(detect_tag_file(), 'a')
	except:
		print 'Some strange problem ocurred when writing to the tag file (' + detect_tag_file() + ').'
		print 'Try again.'
		print
		raise SystemExit(1)
	'Writing tag in the file'
	tag_file.write(id+'\n')


'''This program marks a valid user id in a tag file if not already marked'''
if __name__ == '__main__':
	'Checking number of arguments'
	if len(sys.argv) != 2:
		'Wrong number of arguments passed'
		usage()
		raise SystemExit(1)
	else:
		'Sleeping for 0.5 seconds to prevent file access problems'
		time.sleep(0.5)
		'Passing two arguments (program name and one parameter string)'
		
		'Checking if the paramenter string is a valid <user_id>'
		if check_id(sys.argv[1]):
			'<user_id> is ready to be marked'
			if check_tag(sys.argv[1]):
				print 'Tag already marked!'
				print 'The tag for', sys.argv[1], 'is already marked at', detect_tag_file()
				print 'Skipping...'
				print
			else:
				mark_tag(sys.argv[1])
				print 'Marking tag now!'
				print 'The tag for', sys.argv[1], 'was marked at', detect_tag_file()
				print 'Done!'
				print
		else:
			'The id passed is a invalid one'
			usage()
			raise SystemExit(1)
	raise SystemExit(0)



