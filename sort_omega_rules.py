#!/usr/bin/env python
# coding=utf8

import sys


if __name__ == '__main__':
  lines = None
  with open(sys.argv[1], 'r') as f:
    lines = f.readlines()
  first, last = None, None
  begin_result = False
  for i in range(len(lines)):
    if first:
      if not lines[i].strip() or lines[i].startswith('* '):
        last = i
        break
    elif begin_result:
      if lines[i].strip():
        first = i
    elif lines[i].startswith('@with result'):
      begin_result = True

  lines = lines[:first] + sorted(lines[first:last]) + lines[last:]
  content = ''.join(lines)
  print content
  with open(sys.argv[1], 'w') as f:
    f.write(content)
