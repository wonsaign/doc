## mybatis-plus
> 开发自苞米豆，是mybaits框架的中间封装层

#### 注意点
* 不能声明Bean -> SqlSessionFactory, 否则不会执行苞米豆内部的sqlsession工厂
```
	@Bean
	public SqlSessionFactory sqlSessionFactory(DataSource dataSource,
                                                  @Qualifier("ibatisConfig") org.apache.ibatis.session.Configuration config) throws Exception {
		SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        config.setMapUnderscoreToCamelCase(true);
        bean.setTransactionFactory(new SpringManagedTransactionFactory());
        bean.setConfiguration(config);
		bean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources(
				"classpath*:mapping/*.xml"));
		return bean.getObject();
	}
```
