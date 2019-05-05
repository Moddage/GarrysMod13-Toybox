if CLIENT then
Downloads = {}
local Main = nil

hook.Add("DrawOverlay", "Funbox_FalseDownloadSystem", function()
	if ( !Main ) then
		Main = vgui.Create( "DContentMain" )
	end
	
	for k, v in pairs(Downloads) do
		if v.f >= 0.99 then -- can't use 1 for some reason, dunno why.
			UpdatePackageDownloadStatus(v.id, v.filename, v.f, "success", 50)
		else
			UpdatePackageDownloadStatus(v.id, v.filename, v.f, "", 2096)
		end
	end
end)

concommand.Add("toybox_test", function()
	local files = {"test.vmt", "test.vtf", "test.mdl", "test.wav"}
	for i=4, math.random(20) do
	UpdatePackageDownloadStatus(math.random(9999), table.Random(files), 0, "", 50)
	end
end)

concommand.Add("toybox_test2", function()
	UpdatePackageDownloadStatus(30, "test.vtf", 0.5, "success", 50)
end)


function UpdatePackageDownloadStatus( id, name, f, status, size )

	local dl = Downloads[ id ]
	
	if ( dl == nil ) then
	
		dl = vgui.Create( "DContentDownload", Main )
		dl.Velocity = Vector( 0, 0, 0 );
		dl.id = id
		dl.filename = name
		dl.DownloadProgress = f
		dl:SetAlpha( 10 )
		dl.speed = math.random(15, 25)
		Downloads[ id ] 	= dl
		Main:Add( dl )
		
	end
	
	dl:Update( f + (math.random(0.0001, 0.0003) * dl.speed), status, name, size );
	
	if ( status == "success" ) then
		
		dl:Bounce()
		Downloads[ id ] = nil
		surface.PlaySound( "garrysmod/content_downloaded.wav" ) 
		
		timer.Simple( 2, function() 
								dl:Remove() 
						end )
	elseif ( status == "failed" ) then
		
		dl:Failed()
		Downloads[ id ] = nil
		surface.PlaySound( "garrysmod/content_downloaded.wav" ) 
		
		timer.Simple( 2, function() 
								dl:Remove() 
						end )
	else
		dl:SetAlpha(math.Clamp(dl:GetAlpha() + 3, 0, 255))
		--dl:GetParent():SetAlpha(0)
	end
	
	Main:OnActivity( Downloads )

end
end


if SERVER then return end

local function GetOverlayPanel()

end

local PANEL = {}

function PANEL:Init()
	
	self:SetSize( 256, 100 )
	self:SetPos( 0, ScrH() + 10 )
	self:SetZPos( 100 )
	
end

function PANEL:Think()

	--self:SetParent( GetOverlayPanel() )
	
	if ( self.LastActivity && (SysTime() - self.LastActivity) > 2 ) then
	
		self:MoveTo( self.x, ScrH() + 5, 0.5, 0.5 )
		self.LastActivity = nil;
		self.MaxFileCount = 0
		
	end
	
	for k, v in pairs( Downloads ) do
	
		local x = (self:GetWide() * 0.5) + math.sin( SysTime() + k*-0.43  ) * self:GetWide() * 0.45
		local y = (20) + math.cos( SysTime() + k*-0.43  ) * 20 * 0.5
		v:SetPos( x-13, y )
		v:SetZPos( y )
		
		v.accel = accel;
	
	end

end

function PANEL:OnActivity( dlt )

	if ( self.LastActivity == nil ) then
		self:MoveTo( self.x, ScrH() - self:GetTall() + 20, 0.1 )
	end

	self.LastActivity = SysTime()

end

function PANEL:PerformLayout()

	self:CenterHorizontal()

end

function PANEL:Add( p )

	local x, y = self:GetPos()
	local ypos = math.random( 20, 25 )

end

vgui.Register( "DContentMain", PANEL, "Panel" )

local PANEL = {}

function PANEL:Init()
	
	self:SetSize( 24, 24 )
	self:NoClipping( true )
	
	self.imgPanel = vgui.Create( "DImage", self );
	self.imgPanel:SetImage( "gui/silkicons/toybox" );
	self.imgPanel:SetSize( 16, 16 )
	self.imgPanel:SetPos( 4, 4 )
	
	self.imgPanel:SetAlpha( 255 )
	
	self.BoxW = 0
	self.BoxH = 0

	--self.imgPanel:AlphaTo( 255, 1, 1 )
	
end

function PANEL:SetUp( name )

	local ext = string.GetExtensionFromFilename( name );
	
	if ( ext == "vmt" ) then 
		self.imgPanel:SetImage( "gui/silkicons/page" );
	elseif ( ext == "vtf" ) then 
		self.imgPanel:SetImage( "gui/silkicons/palette" );
	elseif ( ext == "mdl" ) then 
		self.imgPanel:SetImage( "gui/silkicons/brick_add" );
	elseif ( ext == "wav" ) then 
		self.imgPanel:SetImage( "gui/silkicons/sound" );
	elseif ( ext == "mp3" ) then 
		self.imgPanel:SetImage( "gui/silkicons/sound" );
	end

end

function PANEL:Update( f, status, name, size )

	self.status = status
	self.f = f;
	self.size = size
	
	if ( self.name != name ) then
		
		self:SetUp( name )
		self.name = name
		
	end

end

function PANEL:Think()

	if ( self.Bouncing ) then
	
		local ft = FrameTime() * 20
		
		self.yvel = self.yvel + 2.0 * ft
		self.xvel = math.Approach( self.xvel, 0.0, ft * 0.01 )
		
		self.xpos = self.xpos + self.xvel * ft * 3
		self.ypos = self.ypos + self.yvel * ft * 3
		
		if ( self.ypos > (ScrH() - 24) ) then
		
			self.ypos = (ScrH() - 24)
			self.yvel = self.yvel * -0.6
			self.xvel = self.xvel * 0.8
		
		end
		
		self:SetPos( self.xpos, self.ypos )
	
	end

end

function PANEL:Paint()
	self.f = self.f or 5

	local r = 255 - 255 * self.f
	local g = 255
	local b = 255 - 255 * self.f
	local a = self.imgPanel:GetAlpha()
	
	if ( self.f == 1.0 && !self.Bouncing ) then
	
		r = 255
		g = 55 + math.Rand( 0, 200 )
		b = 5
	
	end
	
	if ( self.DownloadFailed ) then
		r = 255
		g = 50
		b = 50
	end
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 20, 20, 20, a * 0.4 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide()-2, self:GetTall()-2, Color( r, g, b, a * 0.7 ) )

	// If the file is bigger than 3MB, give us some info.
	if ( self.f < 1.0 && self.size > (1024 * 1024 * 3) ) then
		self:DrawSizeBox( a )
	end

end

function PANEL:DrawSizeBox( a )

	local x = (self.BoxW - self:GetWide()) * -0.5
	local txt = math.Round( self.f * 100, 2 ) .."% of ".. string.NiceSize( self.size )

	self.BoxW, self.BoxH = draw.WordBox( 4, x, self.BoxH * -1.1, txt, "DefaultSmall", Color( 50, 55, 60, a * 0.8 ), Color( 255, 255, 255, a ) )

end

function PANEL:Bounce()

	local x, y = self:LocalToScreen( 0, 0 )
	self:SetParent( nil )
	self:SetPos( x, y )
	
	self.Bouncing = true
	
	self.xvel = math.random( -12, 12 )
	self.yvel = math.random( -20, -10 )
	
	self.xpos = x
	self.ypos = y
	
	self.imgPanel:AlphaTo( 0, 1, 1 )

end

function PANEL:Failed()
	self.DownloadFailed = true;
end

vgui.Register( "DContentDownload", PANEL, "DPanel" )