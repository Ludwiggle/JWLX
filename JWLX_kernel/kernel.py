from ipykernel.kernelbase import Kernel
from more_itertools import unique_everseen

import os


def wl_response(wl_cell):
        jwlsin = open('/dev/shm/jwlsin', 'w')
        jwlsin.write(wl_cell)
        jwlsin.close()
        return os.popen('cat /dev/shm/jwlsin | nc 127.0.0.1 5858').read()

def blank_chars(s:str, char_list:list):
    for c in char_list:
        s = s.replace(c, ' ')
    return s

WNames = wl_response('StringRiffle@Names@"System`*"').split()

class JWLX_kernel(Kernel):
    implementation = 'JWLX'
    implementation_version = '2.1'
    language = 'Wolfram Language'
    language_info = {'name': 'WolframScript',
                     'codemirror_mode': 'mathematica',
                     'mimetype': 'text/x-mathematica',
                     'file_extension': '.wl'}                 
    banner = "Jupyter for Wolfram Language on linuX"

    ####
    def do_execute(self, code, silent, store_history=False, user_expressions=None,
                   allow_stdin=False):
                       
        stream_content = {'name': 'stdout', 'text': wl_response(code)}
        self.send_response(self.iopub_socket, 'stream', stream_content)

        return {'status': 'ok',
                'execution_count': self.execution_count,
                'payload': [],
                'user_expressions': {}}
               
    ####
    def do_complete(self, code, cursor):

        response = {'matches':[], 'cursor_start':0, 'cursor_end':cursor, 'status':'ok'}

        tail = code[:cursor]
       
        if not tail or tail[-1] == ' ':
            return response

        token = blank_chars(tail, list(';@/?,.><:[](){}_-+*#="~&|!')).split()[-1]
                                    
        allWNames = wl_response('StringRiffle@Names@"Global`*"').split() + WNames

        response['matches'] = sorted(filter(lambda _m: _m.startswith(token), allWNames))
        response['cursor_start'] = cursor - len(token)

        return response