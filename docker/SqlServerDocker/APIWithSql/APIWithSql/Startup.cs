using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using APIWithSql.Data;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;


namespace APIWithSql
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // we are defining the Connection String, the “db” you see in the ‘Server=’ needs to be mapped to exactly what you have 
            //in the “Docker-Compose.yml” file, which is where you define the ‘Services’ that Docker will be creating for you 
            //[Services is analogous to Containers]

            //var connection = @"Server=db;Database=FabsEvals;User=sa;Password=PassW0rd;";
            var connection = Configuration["ConnectionString"];
            services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(connection));
            services.AddScoped<iSpeakerEvalsRepository, SpeakerEvalsRepository>();

            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory, ApplicationDbContext evalDataContext)
        {
            loggerFactory.AddConsole(Configuration.GetSection("Logging"));
            loggerFactory.AddDebug();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            //uses to seed the SQLCore Database in the Docker Container
            evalDataContext.EnsureSeedDataForContext();
            app.UseMvc();
        }
    }
}
