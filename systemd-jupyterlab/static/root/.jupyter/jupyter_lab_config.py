c = get_config()
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.LabApp.open_browser = False
c.ServerApp.root_dir = '/root/'
c.ServerApp.tornado_settings = {
    'headers': {
        'Content-Security-Policy': "frame-ancestors * 'self' "
    }
}
c.ServerApp.allow_remote_access = True
c.ServerApp.base_url = '/jupyter/'
c.ServerApp.allow_origin = '*'
