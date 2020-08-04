--create database ContactManager

CREATE TABLE [dbo].[contacts](    
    [Id] [int] IDENTITY(1,1) NOT NULL,    
    [Firstname] [nvarchar](50) NULL,    
    [Lastname] [nvarchar](50) NULL,    
    [Phone] [nvarchar](50) NULL,    
    [Email] [nvarchar](50) NULL,    
    [Password] [nvarchar](50) NULL,    
 CONSTRAINT [PK_contacts] PRIMARY KEY CLUSTERED     
(    
    [Id] ASC    
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]    
) ON [PRIMARY]    
GO    








